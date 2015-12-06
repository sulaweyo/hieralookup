hieralookup
===========

A web service for doing hiera lookups based on facts that are handed over in the request.
Highly stripped down from dalen/hieralookup but the credits go to him for the initial implementation!

I push a set of fact values instead of going to puppetdb as i don't have it in my env currently
and i only need some values for my hierarachy in the first place. So i just push these over in the 
request and query hiera based on that.

Forward lookup
--------------

/hiera/:[/&lt;resolution_type&gt;]/:/&lt;key?fact=value

- __key__ is the hiera key to look up
- __resolution_type__ is optional and should be either _array_, _priority_ or _hash_ with _priority_ being the default
- Any additional URL parameters are used for overriding facts

