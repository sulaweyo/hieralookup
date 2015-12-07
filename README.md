hieralookup
===========

A web service for doing hiera lookups based on facts that are handed over in the request.
Highly stripped down from dalen/hieralookup so the main credits go to him for the initial implementation!

I push a set of fact values instead of going to puppetdb as i don't have it in my env currently
and i only need some values for my hierarachy in the first place. So i just push these over in the 
request and query hiera based on that. In this implementation there is just the kernel fact but it can obviously be extended to how many facts are required for any specific environment.

Lookup
--------------

/hiera/:[/&lt;resolution_type&gt;]/:key?fact=value

- __resolution_type__ is optional and should be either _array_, _priority_ or _hash_ with _priority_ being the default
- __key__ is the hiera key to look up
- All the additional arguments are used as fact values. 

Query
--------------
The query folder contains a Ruby class that can be used to query this service from a fact.