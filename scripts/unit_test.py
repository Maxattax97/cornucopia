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
import re

#  TEMP_DIR_PATH = None
TEMP_DIR_PATH = tempfile.mkdtemp()

#  mod_re = (r"\bmodule\s+(", r")\s*\(\s*")
#  func_re = (r"\bfunction\s+(", r")\s*\(")

#  class Timeout(Exception): pass

#  def extract_definitions(fpath, name_re=r"\w+", def_re=""):
#      regex = name_re.join(def_re)
#      matcher = re.compile(regex)
#      return (m.group(1) for m in matcher.finditer(fpath.read()))

#  def extract_mod_names(fpath, name_re=r"\w+"):
#      return extract_definitions(fpath, name_re=name_re, def_re=mod_re)

#  def extract_func_names(fpath, name_re=r"\w+"):
#      return extract_definitions(fpath, name_re=name_re, def_re=func_re)


def collect_modules(directory=None):
    """ Generates a hashtable of absolute paths to module names.

    A "module" in this case is not a module code block, but rather the whole
    file as included. Each tested file contains a module code block that unit
    tests the whole file, using the naming scheme "test_moduleName".
    """
    directory = directory or os.path.join(
        os.path.dirname(os.path.abspath(__file__)), os.pardir)
    test_files = {}
    for _root, _dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.scad') and \
                    not (filename.startswith('all.') or
                         filename.startswith('all_recurse.') or
                         'test' in filename):
                test_files[os.path.realpath(filename)] = \
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
            # os.system("cp %s %s/" % (fpath, temppath))
            #  print(module_name, 'wazoo', [module_name, path])
        print(pairs)
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
    test_code = """// Generated test file for module '%s' located at %s.
include <%s>

// Add a simple cube so that a geometry always exists to form a cube in 
// the top level.
cube([1,1,1]);
test_%s();""" % (module_name, module_path,
                 re.sub('.*cornucopia/', 'cornucopia/', module_path),
                 module_name)
    print(test_code)
    code_file.write(test_code)
    code_file.flush()
    result = compile_openscad(code_path, stl_path)
    assert result[0] == 0
    #  assert 'warning' not in result[1].strip().lower()
    assert 'error' not in result[1].strip().lower()
    assert os.path.getsize(stl_path) > 2
    return result


#  def test_compile_modules():
#      discovered_modules = collect_modules()
#      print(discovered_modules)
#      for path, module_name in discovered_modules.items():
#          result = compile_module(path, module_name)
#  assert result[0] == 0
#  assert 'warning' not in result[1].strip().lower()
#  assert 'error' not in result[1].strip().lower()
#  assert os.path.getsize(stl_path) > 2

#  shutil.rmtree(TEMP_DIR_PATH, ignore_errors=True)

#  def call_openscad(path, stlpath, timeout=5):
#      if sys.platform == 'darwin': exe = 'OpenSCAD.app/Contents/MacOS/OpenSCAD'
#      else: exe = 'openscad'
#      command = [exe, '-s', str(stlpath),  str(path)]
#      print command
#      if timeout:
#          try:
#              proc = Popen(command,
#                  stdout=PIPE, stderr=PIPE, close_fds=True)
#              calltime = time.time()
#              time.sleep(0.05)
#              #print calltime
#              while True:
#                  if proc.poll() is not None:
#                      break
#                  time.sleep(0.5)
#                  #print time.time()
#                  if time.time() > calltime + timeout:
#                      raise Timeout()
#          finally:
#              try:
#                  proc.terminate()
#                  proc.kill()
#              except OSError:
#                  pass
#
#          return (proc.returncode,) + proc.communicate()
#      else:
#          output = commands.getstatusoutput(" ".join(command))
#          return output + ('', '')

#  def parse_output(text):
#      pass

#  temppath = py.test.ensuretemp('MCAD')

#  def compile_module(modname, modpath):
#      tempname = modpath.basename + '-' + modname + '.scad'
#      fpath = temppath.join(tempname)
#      stlpath = temppath.join(tempname + ".stl")
#      f = fpath.open('w')
#      code = """
#  // Generated test file.
#  include <%s>
#
#  %s();
#  """ % (modpath, modname)
#      print code
#      f.write(code)
#      f.flush()
#      output = call_openscad(path=fpath, stlpath=stlpath, timeout=15)
#      print output
#      assert output[0] is 0
#      for s in ("warning", "error"):
#          assert s not in output[2].strip().lower()
#      assert len(stlpath.readlines()) > 2

#  def test_file_compile(modpath):
#      stlpath = temppath.join(modpath.basename + "-test.stl")
#      output = call_openscad(path=modpath, stlpath=stlpath)
#      print output
#      assert output[0] is 0
#      for s in ("warning", "error"):
#          assert s not in output[2].strip().lower()
#      assert len(stlpath.readlines()) == 2

#  call_openscad("./util/util.py", "./demo.stl")
