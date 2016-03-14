# OVFTool Controller

This script simplifies the use of OVFTool to upload and download of vApps / OVF / OVA and ISO images to vCloud Director

## Pre-requisites
You will need Ruby (built on 2.0 not tested other versions)
and
OVFTool:
https://my.vmware.com/web/vmware/details?downloadGroup=OVFTOOL400&productId=353

##Usage:
Example usage is shown in upload_example.rb

Basically, a Hash is passed with configuration parameters:
E.g
```ruby
vcdconfig= {
  :source => 'C:\Users\tlawrence\Downloads\coreos_production_vmware_ova.ova',
  :directory => 'C:\Users\tlawrence\Downloads',
  :vapp => 'name of single vapp to download',
  :user => '123.456.7890',
  :org => 'x-xxx-x-xxxx',
  :pass => 'secretpassword',
  :url => 'vcloud_api_hostname',
  :catalogue => 'catalogue name',
  :vdc => 'vdc name'
}
```

then create an object:

```ruby
require './ovftool'

ovftool = ovftool.new(vcdconfig)
```

Then to upload the OVF / OVA or ISO specified in the config hash (determined by file extension):
```ruby
ovftool.upload
```

To Download the vApp configured in :vapp (must be powered off):
```
ovftool.download
```

And to Download a list of vApps in multiple Threads:
```ruby
vapp_list = ['vapp1','vapp2','vapp3','etc']
ovftool.download_many(vapp_list)
```

NB: download_many currently does weird studd with STDOUT so progress indication might look a little strange. Works ok though. Max Threads currently set to 5