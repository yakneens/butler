import os
from setuptools import setup

# Utility function to read the README file.
# Used for the long_description.  It's nice, because now 1) we have a top level
# README file and 2) it's easier to type in the README file than to put a raw
# string in below ...


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name="analysis_run_tracker",
    version="0.0.1",
    author="Sergei Iakhnin",
    author_email="llevar@gmail.com",
    description=("Tools for tracking genomic analysis runs"),
    license="Apache 2.0",
    keywords="genomic analysis run tracker",
    url="http://github.com/llevar/germline-regenotyper",
    packages=['tracker', 'tests'],
    long_description=read('README.md'),
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Topic :: Utilities"
    ],
)
