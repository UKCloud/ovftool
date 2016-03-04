require '.\ovftool'

vcdconfig= {
  :source => 'C:\Users\tlawrence\Downloads\coreos_production_vmware_ova.ova',
  :user => '123.456.7890',
  :org => 'x-xxx-x-xxxx',
  :pass => 'secretpassword',
  :url => 'vcloud_api_hostname',
  :catalogue => 'catalogue name',
  :vdc => 'vdc name'
}


ovf = Ovftool.new(vcdconfig)






