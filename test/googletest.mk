#  Copyright (c) 2015, Intel Corporation
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in
#        the documentation and/or other materials provided with the
#        distribution.
#
#      * Neither the name of Intel Corporation nor the names of its
#        contributors may be used to endorse or promote products derived
#        from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY LOG OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

check-am: libgmock.a libgtest.a

clean-local: clean-local-gmock

googlemock_version = 1.7.0
googlemock = gmock-$(googlemock_version)
googletest = $(googlemock)/gtest
googlemock_archive = $(googlemock).zip
googlemock_sha1 = f9d9dd882a25f4069ed9ee48e70aff1b53e3c5a5

$(googlemock_archive):
	wget http://googlemock.googlecode.com/files/$(googlemock_archive)
	if [ $$(sha1sum $(googlemock_archive) | awk '{print $$1}') != $(googlemock_sha1) ]; then exit -1; fi

$(googlemock)/VERSION: $(googlemock_archive)
	rm -rf $(googlemock)
	unzip $(googlemock_archive)
	echo $(googlemock_version) > $(googlemock)/VERSION

libgmock.a: $(googlemock)/VERSION
	$(CXX) $(CXXFLAGS) -isystem $(googlemock)/include -I$(googlemock) -isystem $(googletest)/include -I$(googletest) -pthread \
	      -c $(googlemock)/src/gmock-all.cc
	ar -rv libgmock.a gmock-all.o

libgtest.a: $(googlemock)/VERSION
	$(CXX) $(CXXFLAGS) -isystem $(googletest)/include -I$(googletest) -pthread \
	      -c $(googletest)/src/gtest-all.cc
	ar -rv libgtest.a gtest-all.o

clean-local-gmock:
	rm -rf libgtest.a libgmock.a $(googlemock)