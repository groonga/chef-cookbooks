groonga Cookbook
================

This cookbook installs and configures groonga. Groonga is an
open-source fulltext search engine and column store.

Requirements
------------

#### Platform

- Debian GNU/Linux
- Ubuntu
- CentOS
- Scientific Linux
- Amazon Linux
- Red Hat
- Fedora
- FreeBSD
- Windows
- Mac OS X

#### Packages

- `apt` - for deb based package system
- `yum` - for RPM based package system
- `homebrew` - for Mac OS X

Attributes
----------

e.g.
#### groonga::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['groonga']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----

#### groonga::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `groonga` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[groonga]"
  ]
}
```

Contributing
------------

e.g.
1. Fork the repository on GitHub
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

License: Apache 2.0

Authors: Kouhei Sutou <kou@clear-code.com>