#########
lfe-disco
#########


Introduction
============

An LFE client library for the `Disco`_ big-data platform.


Dependencies
------------

This project assumes that you have `rebar`_ installed somwhere in your
``$PATH``.

This project depends upon the following, which installed to the ``deps``
directory of this project when you run ``make deps``:

* `LFE`_ (Lisp Flavored Erlang; needed only to compile)
* `lfeunit`_ (needed only to run the unit tests)


Installation
============

To inlcude ``lfe-disco`` in your project, simply update the deps section
of your ``rebar.config``:

.. code:: erlang

    {deps, [
      {lfe, ".*", {git, "git://github.com/rvirding/lfe.git", "develop"}},
      {'lfe-disco',
        ".*", {git, "git://github.com/lfe/lfe-disco.git"}}
    ]}


Usage
=====

TBD (project still in-progress; worker protocol will likely be the first bit done)


.. Links
.. -----
.. _Disco: https://github.com/discoproject
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _lfeunit: https://github.com/lfe/lfeunit
