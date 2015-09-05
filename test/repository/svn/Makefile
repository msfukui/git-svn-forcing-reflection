start:
	svnserve -d \
		--pid-file=svnserve.pid \
		--log-file=svnserve.log \
		--config-file=svnserve.conf \
		-r svn-repo
stop:
	kill `cat svnserve.pid`; \
	rm -f svnserve.pid
