#!/usr/bin/env python

from subprocess import call
from os import system

import argparse


#Get command line options
parser = argparse.ArgumentParser(description='Clock & Reset Run Script Options')

#Get Clock & Reset testnames from command
parser.add_argument('-t', type=str, help='Enter Clock Reset testname')

parser.add_argument('--clean', action='store_true', help='Clean LOGs..')
parser.add_argument('--gui', action='store_true', help='GUI Simulation')

args = parser.parse_args()


def create_lib():
    system('vlib work')
    system('vmap work work')

def compile_files():
    system('vlog -work work -f ClockReset.f +define+UVM_NO_DPI')

def simulate():
    if args.gui:
        system('vsim work.ClockResetGenerator -do "run -all;" -sv_seed random +UVM_TESTNAME={0}'.format(args.t))
    else:
        system('vsim work.ClockResetGenerator -c -do "run -all; exit;" -sv_seed random +UVM_TESTNAME={0}'.format(args.t))


def clean():
    system('rm -r modelsim.ini transcript vsim.wlf work')


def main():

    if args.clean:
        clean()
    else:
        create_lib()
        compile_files()
        simulate()


if __name__ == '__main__':
    main()
