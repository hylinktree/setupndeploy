import sys
import argparse
import requests
import json
# from time import sleep
from datetime import datetime, timedelta

# doflush=True, for python3
hosta = 'http://localhost:9201'


def Runner(self, url):
    try:
        print('Run '+url)  # , flush=doflush)
        sys.stdout.flush()  # for python2
        r = requests.get(url)
        while True:
            if r.status_code != 200:
                break
            y = json.loads(r._content)
            if y['code'] == 0:
                print('   Success: code=%d, status=%s' %
                      (y['code'], y['status']))  # , flush=doflush)
                sys.stdout.flush()  # for python2
                return True
            break
        print('   !!FAIL!! ret=%d reason=%s content=%s' %
              (r.status_code, r.reason, r._content))  # , flush=doflush)
        sys.stdout.flush()  # for python2
    except Exception as ex:
        print('   !!ERROR!! '+str(ex))  # , flush=doflush)
        sys.stdout.flush()  # for python2
    return False


class TChain(object):
    runner = Runner

    def __init__(self):
        self.children = []

    def add(self, fntask):
        self.children.append(fntask)
        return self

    def exe(self, run, break_on_failure=True):
        # tb = datetime.now()
        # ta = tb + timedelta(days=-1)
        ta = datetime.now() + timedelta(days=-1)
        tb = ta
        for p in self.children:
            so = p(ta, tb)
            if not run:
                print(so) #, flush=doflush)
                sys.stdout.flush()  # for python2
                continue
            if not TChain.runner(self, so) and break_on_failure:
                return False
        return True


def test(host, run):

    lst = [
        # chain of edc tracking, daily
        TChain().add(
            lambda ta, tb: host+'/stat/between_edctrackinoutefficiency/day/%s/%s' % (
                ta.strftime('%Y-%m-%d'), tb.strftime('%Y-%m-%d'))
        ),

        # chain of wis by hour, from day to year
        TChain().add(  # dayjob 2006-01-02
            lambda ta, tb: host+'/stat/between_wisByHour/day/%s/%s' % (
                ta.strftime('%Y-%m-%d'), tb.strftime('%Y-%m-%d'))
        ).add(  # weekjob 2006-ww
            lambda ta, tb: host+'/stat/between_wisByHour/week/%s/%s' % (
                ta.strftime('%Y-%V'), tb.strftime('%Y-%V'))
        ).add(  # monthjob 2006-mm
            lambda ta, tb: host+'/stat/between_wisByHour/month/%s/%s' % (
                ta.strftime('%Y-%m'), tb.strftime('%Y-%m'))
        ).add(  # yearjob 2006
            lambda ta, tb: host+'/stat/between_wisByHour/year/%s' % (
                ta.strftime('%Y'))
        ),
        TChain().add(  # dayjob 2006-01-02
            lambda ta, tb: host+'/stat/between_strip/day/%s/%s' % (
                ta.strftime('%Y-%m-%d'), tb.strftime('%Y-%m-%d'))
        ).add(  # weekjob 2006-ww
            lambda ta, tb: host+'/stat/between_strip/week/%s/%s' % (
                ta.strftime('%Y-%V'), tb.strftime('%Y-%V'))
        ).add(  # monthjob 2006-mm
            lambda ta, tb: host+'/stat/between_strip/month/%s/%s' % (
                ta.strftime('%Y-%m'), tb.strftime('%Y-%m'))
        ).add(  # yearjob 2006
            lambda ta, tb: host+'/stat/between_strip/year/%s' % (
                ta.strftime('%Y'))
        )
    ]
    for y in lst:
        y.exe(run)


if __name__ == "__main__":
    print('%s enters on %s' % (sys.argv[0], datetime.now()))
    sys.stdout.flush()  # for python2
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', required=False, default=hosta,
                        help='The host:port, defaults to '+hosta)
    parser.add_argument('--run', action="store_true", required=False, default=False,
                        help='run this servivce')
    xargs, _ = parser.parse_known_args()

    test(xargs.host, xargs.run)

    print('%s leaves on %s' % (sys.argv[0], datetime.now()))
    sys.stdout.flush()  # for python2
