from __future__ import division, print_function

from functools import partial
from math import sin, floor
from time import sleep
from itertools import count

def wave(t):
    def wave(t, x):
        k=1/4
        w=1/8
        value = floor(4*sin(k*x-w*t)) + 4
        return "{} {}".format(
            x,
            " ".join(map(lambda on: "1" if on else "0", map(lambda v: value==v, range(8)))),
        )


    return "\n".join(
        map(partial(wave, t), range(8))
    )

list(map(lambda i: print(wave(i)), count()))
