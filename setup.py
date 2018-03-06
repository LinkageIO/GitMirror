#!/usr/bin/env python3

from setuptools import setup, find_packages, Extension
import os

import io
import re

def read(*names, **kwargs):
    with io.open(
        os.path.join(os.path.dirname(__file__), *names),
        encoding=kwargs.get("encoding", "utf8")
    ) as fp:
        return fp.read()

def find_version(*file_paths):
    version_file = read(*file_paths)
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")

setup(
    name = 'gitmirror',
    version = find_version('gitmirror','__init__.py'),
    packages = find_packages(),
    scripts = [
        'gitmirror/pushEGGL',
        'gitmirror/gitmirror'
    ],
    ext_modules = [],
    cmdclass = {
    },

    package_data = {
        '':['*.cyx']    
    },
    install_requires = [		
    ],
    include_package_data=True,

    author = 'Rob Schaefer',
    author_email = 'rob@linkage.io',
    description = 'A program for mirroring github repos.',
    license = "Copyright Linkage Analytics 2016. Available under the MIT License",
    url = 'linkage.io'
)
