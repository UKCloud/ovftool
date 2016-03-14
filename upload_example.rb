require '.\ovftool'

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


ovf = Ovftool.new(vcdconfig)

#upload single ISO /OVF / OVA(as specified in :source)

ovf.upload

#download single vapp (as specified in :vapp)

ovf.download

#download multiple vApps simultaneously (from the vdc specified in :vdc)
vapp_list = ['vapp1','vapp2','vapp3','etc']
ovf.download_many(vapp_list)




