#----------------------------------------------------------
# Start Date: 8 Apr 2020
# Last Modified:
# Author: Milan Kubavat
# 
# Description: Python script to compile and run using
#              questa sim 
#----------------------------------------------------------

#!/usr/bin/env python

from subprocess import call
from os import system

import argparse

#Get command line options
parser = argparse.ArgumentParser(description='Clock & Reset Run Script Options')

#Get Clock & Reset testnames from command
parser.add_argument('-t', type=str, help='Enter Clock Reset testname')

parser.add_argument('--clean', action='store_true', help='Clean LOGs..')
parser.add_argument('--comp', action='store_true', help='Compile VIP..')
parser.add_argument('--gui', action='store_true', help='GUI Simulation')

args = parser.parse_args()

def create_lib():
    system('vlib work')
    system('vmap work work')

def compile_files():
    system('vlog -work work -f spi_files.f +define+UVM_NO_DPI')

def simulate():
    if args.gui:
        system('vsim work.top -do "run -all;" -sv_seed random +UVM_TESTNAME={0}'.format(args.t))
    else:
        system('vsim work.top -c -do "run -all; exit;" +UVM_TESTNAME={0}'.format(args.t))

def clean():
    system('rm -r modelsim.ini transcript vsim.wlf work')

def main():

    if args.clean:
        clean()
    elif args.comp:
        create_lib()
        compile_files()
    else:
        create_lib()
        compile_files()
        simulate()

if __name__ == '__main__':
    main()
