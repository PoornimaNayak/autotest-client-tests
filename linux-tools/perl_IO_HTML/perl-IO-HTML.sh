#!/bin/bash
############################################################################################
## Copyright 2003, 2015 IBM Corp                                                          ##
##                                                                                        ##
## Redistribution and use in source and binary forms, with or without modification,       ##
## are permitted provided that the following conditions are met:                          ##
##      1.Redistributions of source code must retain the above copyright notice,          ##
##        this list of conditions and the following disclaimer.                           ##
##      2.Redistributions in binary form must reproduce the above copyright notice, this  ##
##        list of conditions and the following disclaimer in the documentation and/or     ##
##        other materials provided with the distribution.                                 ##
##                                                                                        ##
## THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS AND ANY EXPRESS       ##
## OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF        ##
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ##
## THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,    ##
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF     ##
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ##
## HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,  ##
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  ##
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                           ##
############################################################################################
## File :       perl-IO-HTML.sh                                              		  ##
##									      		  ##
## Description: Test for perl-IO-HTML package                                             ##                                                             
## Author:      Charishma M <charism2@in.ibm.com>                             		  ##
##                                                                                 	  ##
############################################################################################

######cd $(dirname $0)
#LTPBIN=${LTPBIN%/shared}/perl_IO_HTML
source $LTPBIN/tc_utils.source
TESTS_DIR="${LTPBIN%/shared}/perl_IO_HTML"
REQUIRED="perl rpm"

################################################################################
# Utility functions                                                            
################################################################################
#                                                                              
# LOCAL SETUP                                                              
################################################################################


function tc_local_setup()
{	
	tc_exec_or_break $REQUIRED || return
        rpm -q perl-IO-HTML >$stdout 2>$stderr
        tc_break_if_bad $? "perl-IO-HTML is not installed properly"
}

function runtests()
{
       pushd $TESTS_DIR >$stdout 2>$stderr
	#release-pod-coverage.t & release-pod-syntax.t tests are skipped, as these tests are for release candidate testing
       TESTS=`ls t/*.t | grep -v "release"`
       TST_TOTAL=`echo $TESTS | wc -w`
	for test in $TESTS;
        do
          	tc_register "Test $test"
                perl $test >$stdout 2>$stderr
		RC=$?
                if [ $RC -eq 0 ]; then
			grep "not ok" $stderr
			[ $? -ne 0 ] && cat /dev/null > $stderr
			tc_pass_or_fail $? "$test failed"
                else
			tc_pass_or_fail $RC "$test failed"
                fi
        done
    	popd >$stdout 2>$stderr

}

################################################################################
#  MAIN                                                           
################################################################################

tc_setup
TST_TOTAL=1
runtests
