#!/usr/bin/python3

import os
import re


def generate_wildcards():
    for root, subdirs, filenames in os.walk('.', topdown=False):
        if not root.startswith('./.') and not root.startswith('./scripts'):
            #  print(root, 'has subdirs', subdirs, 'and files', filenames)
            all_file = open(root + '/all.scad', 'w+')
            all_contents = ''
            for item in filenames:
                if not item.startswith('all') and item.endswith('.scad'):
                    target_path = root + '/' + item
                    if os.path.exists(target_path):
                        include_str = 'cornucopia' + target_path[1:]
                        all_contents += 'include <%s>\n' % include_str
            #  print(all_contents)
            all_file.write(all_contents)
            all_file.flush()

            recurse_file = open(root + '/all_recurse.scad', 'w+')
            recurse_contents = ''
            for item in subdirs:
                target_path = root + '/' + item + '/all_recurse.scad'
                if os.path.exists(target_path):
                    include_str = 'cornucopia' + target_path[1:]
                    recurse_contents += 'include <%s>\n' % include_str
            if os.path.exists(root + '/all.scad'):
                recurse_contents += 'include <%s>\n' % (
                    'cornucopia' + root[1:] + '/all.scad')
            #  print(recurse_contents)
            recurse_file.write(recurse_contents)
            recurse_file.flush()


generate_wildcards()
