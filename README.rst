################
lfe-disco-worker
################


Introduction
============

Add content to me here!


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

To inlcude ``lfe-disco-worker`` in your project, simply update the deps section
of your ``rebar.config``:

.. code:: erlang

    {deps, [
      {lfe, ".*", {git, "git://github.com/rvirding/lfe.git", "develop"}},
      {'lfe-disco-worker',
        ".*", {git, "git://github.com/lfe/lfe-disco-worker.git"}}
    ]}


Usage
=====

Add content to me here!


.. Links
.. -----
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _lfeunit: https://github.com/lfe/lfeunit
