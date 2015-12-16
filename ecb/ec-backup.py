#!/usr/bin/python

def is_fqdn(hostname):
    if len(hostname) > 255:
        return False
    if hostname[-1] == ".":
        hostname = hostname[:-1] # strip exactly one dot from the right, if present
    allowed = re.compile("(?!-)[A-Z\d-]{1,63}(?<!-)$", re.IGNORECASE)
    return all(allowed.match(x) for x in hostname.split("."))

def _error(message):
    print( ("[ERROR] %s" % message))

def _info(message):
    print("[INFO] %s" % message)

def _debug(message):
    print("[DEBUG] %s" % message)

def _help():
    print("HELP - TBD")

print('''
 .-----------------------.
 |  ENONIC CLOUD BACKUP  |
 '-----------------------'
''')

_info("Importing modules")
import re
import subprocess
import git
import yaml
import sys
import os
import shutil
import docker

# check for amount of arguments
_info("Check for command line arguments")
if len(sys.argv) != 2:
    _error("Incorrect number of arguments: " + len(sys.argv))
    _help()
    sys.exit(1)

# get hostname from command line arguments
hostname = sys.argv[1]

# check if argument is proper FQDN
_info("Check if argument is proper FQDN")
if is_fqdn(hostname) == False:
    _error("Hostname contains invalid characters.")
    _help()
    sys.exit(1)

# clone git repo with host details
#git_server = 'https://github.com/mbeenonic/'
#repo_name = 'io-' + hostname
#repo_dirname = hostname + '.git'
#repo_address = git_server + repo_name
#
#if os.path.exists(repo_dirname):
#    _info("Found old version of " + hostname + " git repo - deleting")
#    shutil.rmtree(repo_dirname)
#
#_info("Clone git repo for " + hostname)
#git.Repo.clone_from(repo_address, repo_dirname)

# get all directories under /services
all_services = []
#for root_dir, children, root_file in os.walk("/services"):
for dir_name in os.listdir("/services"):
    all_services.append('/services/' + dir_name)

for dirname in all_services:

    # read YML file (docker-compose.yml)
    _info("Read yaml config")
    if os.path.isfile(dirname + "/docker-compose.yml"):
        with open(dirname + "/docker-compose.yml", 'r') as f:
            ecb_config = yaml.load(f)
            #print(yaml.dump(ecb_config))

    # find running containers to be backed up
    _info("Get container types to be backed up")
    container_types_to_backup = []
    for (ctype, cmeta) in ecb_config.items():
        #print(ctype)
        #print(cmeta.get('labels', "brak klucza"))
        #print(cmeta['labels'])
        #print(cmeta['labels']['io.enonic.backup'])
        if 'labels' in cmeta.keys() and cmeta['labels']['io.enonic.backup'] == 'yes':
            container_types_to_backup.append(ctype)

    # TBD: change to nicer format
    _info(container_types_to_backup)

    _info("Connecting to host docker demon")
    docker_client = docker.Client(base_url='unix://var/run/docker.sock', version="auto")

    _info("Get names of the containers to be backed up")
    containers_to_backup = []
    for image in docker_client.containers():
        for container_name in image['Names']:
            #if any(container_type in container_name for container_type in container_types_to_backup):
            docker_compose_prefix = hostname.replace('.', '')
            container_types_re_string = '|'.join(container_types_to_backup)

            _debug("docker_compose_prefix: %s, container_types_re_string: %s" % (docker_compose_prefix, container_types_re_string))
            re_string = '^' + docker_compose_prefix + '_(' + container_types_re_string + ')_[0-9]+$'
            _debug("re_string: " + re_string)
            p = re.compile(re_string, re.IGNORECASE)
            if p.match(container_name):
                _debug("matching against: '" + container_name + "'")
                containers_to_backup.append(container_name)

    _info(containers_to_backup)

    sys.exit(0)

    for i in containers_to_backup:
        if not 'out' in locals():
            out = i['name']
        else :
            out = out + ', ' + i['name']
    _info("Containers to be backed up: " + out)

    # for each container to be backed up:
    script_path = "/bin"

    for container_name in containers_to_backup:
        _info("")
        _info("Staring backup of " + container_name['name'])

        # run pre-script
        filename = repo_dirname + '/' + ecb_config[container_name['type']]["pre-script"]
        try :
            _info("Copy pre-script to target container " + container_name['name'])
            docker_client.put_archive(container_name['name'], "/bin", filename)
        except docker.errors.APIError, e:
            _error(e)

        # backup
        _info("")
        _info("Do actual backup")
        _info("")

        # run post-script
        filename = repo_dirname + '/' + ecb_config[container_name['type']]["post-script"]
        try :
            _info("Copy post-script to target container " + container_name['name'])
            docker_client.put_archive(container_name['name'], "/bin", filename)
        except docker.errors.APIError, e:
            _error(e)

# write log/email (?)

#If the script has no shebang then you need to specify shell=True:
#rc = call("./sleep.sh", shell=True)
