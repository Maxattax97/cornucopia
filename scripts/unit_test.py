#! /usr/bin/python3
"""
Python unit testing module for OpenSCAD compilation checks adapted from MCAD.
https://github.com/openscad/MCAD/tree/dev
"""

#  from subprocess import Popen, PIPE
#  import py, re, os, os.path, signal, time, commands, sys
import os
import subprocess
import tempfile
import shutil
import string

#  TEMP_DIR_PATH = None
TEMP_DIR_PATH = tempfile.mkdtemp()


def snake_to_camel_case(snake_string):
    pieces = snake_string.split('_')
    return pieces[0] + ''.join(item.title() for item in pieces[1:])


def collect_modules(directory=None):
    """ Generates a hashtable of absolute paths to module names.

    A "module" in this case is not a module code block, but rather the whole
    file as included. Each tested file contains a module code block that unit
    tests the whole file, using the naming scheme "test_moduleName".
    """
    directory = directory or './'
    test_files = {}
    for root, _dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.scad') and \
                    not (filename.startswith('all.') or
                         filename.startswith('all_recurse.')):
                #  print(root + '/' + filename)
                test_files[root + '/' + filename] = \
                    os.path.basename(filename)[:-1 * len('.scad')]
    return test_files


def compile_openscad(source_path, stl_path, timeout=5):
    try:
        output = subprocess.check_output(
            ['openscad', '-o',
             str(stl_path), str(source_path)],
            timeout=timeout,
            stderr=subprocess.STDOUT)
        return 0, str(output)
    except subprocess.CalledProcessError as err:
        return err.returncode, str(err.output)


def pytest_generate_tests(metafunc):
    if 'module_path' in metafunc.funcargnames and \
            'module_name' in metafunc.funcargnames:
        #  TEMP_DIR_PATH = tempfile.mkdtemp()
        pair_ids = []
        pairs = []
        i = 0
        for path, module_name in collect_modules().items():
            pairs.append([module_name, path])
            pair_ids.append(str(i) + '.' + module_name)
            i += 1
        #  print(pairs)
        metafunc.parametrize(
            ids=pair_ids,
            argnames=['module_name', 'module_path'],
            argvalues=pairs)


def pytest_sessionfinish():
    shutil.rmtree(TEMP_DIR_PATH, ignore_errors=True)


def test_compile_module(module_name, module_path):
    temp_filename = 'test_' + module_name
    code_path = os.path.join(TEMP_DIR_PATH, temp_filename + '.scad')
    stl_path = os.path.join(TEMP_DIR_PATH, temp_filename + '.stl')
    code_file = open(code_path, 'w+')
    fixed_module_name = snake_to_camel_case(module_name)
    fixed_module_name = fixed_module_name[0].upper() + fixed_module_name[1:]
    test_code = """// Generated test file for module '%s' located at %s.
include <%s>
include <cornucopia/util/unit_test.scad>

// Add a simple cube so that a geometry always exists to form a cube in
// the top level.
cube([1,1,1]);
test%s();""" % (module_name, module_path, 'cornucopia' + module_path[1:],
                fixed_module_name)
    #  print(test_code)
    code_file.write(test_code)
    code_file.flush()
    result = compile_openscad(code_path, stl_path)
    cleaned_output = result[1].strip().lower()
    assert 'warning' not in cleaned_output
    assert 'error' not in cleaned_output
    assert 'failed' not in cleaned_output
    assert result[0] == 0
    assert os.path.getsize(stl_path) > 2
    return result


#  print(collect_modules())
