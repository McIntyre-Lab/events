# Setup event_analysis
from setuptools import setup, find_packages
from setuptools.command.install import install
from codecs import open
import os
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here,'README.md'), encoding='utf-8') as f:
    long_description=f.read()

## Run setup 

setup(
    name='event_analysis',

    # Version
    version="1.0.16",

    description="Event Analysis python workflow",
    long_description=long_description,

    # URL to github
    url="https://github.com/McIntyre-Lab/events.git",

    # Author details
    author="Jeremy R. B. Newman",
    author_email="jrbnewman@ufl.edu",

    license="MIT",

    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 5 - Production/Stable',

        # Indicate who your project is intended for
        'Intended Audience :: Geneticists',
        'Topic :: Software Development :: Libraries :: Python Packages',

        # Pick your license as you wish (should match "license" above)
        'License :: OSI Approved :: BSD License',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language:: Python:: 3:: Only',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],

    # What does your project relate to?
    keywords='genetics',

    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=find_packages(exclude=['contrib', 'docs', 'tests']),
    #packages=['gffutils','numpy','pandas','pybedtools'],

    # List run-time dependencies here.  These will be installed by pip when
    # your project is installed.
    install_requires=['pandas==0.23.1','pybedtools==0.7.10','numpy==1.14.3','gffutils==0.9'],
)
