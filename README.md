hieralookup
===========

A web service for doing hiera lookups and reverse hiera lookups
Highly stripped down from forked hieralookup!

I push a set of fact values instead of going to puppetdb.

Forward lookup
--------------

/hiera/&lt;key&gt;[/&lt;resolution_type&gt;][?fact=override]

- __key__ is the hiera key to look up
- __resolution_type__ is optional and should be either _array_, _priority_ or _hash_ with _priority_ being the default
- Any additional URL parameters are used for overriding facts

