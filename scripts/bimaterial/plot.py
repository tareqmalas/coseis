#!/usr/bin/env python
"""
Bimaterial problem
"""
import sord, pylab

sl = sord.util.ndread( '~/run/bimat/out/slip', [401,200] )
pylab.plot( sl[:,::20] )
pylab.show()

