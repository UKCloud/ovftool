
class Ovftool
  attr_accessor :source, :target
  
  
  def initialize(creds)
    self.source = creds[:source]
    file_info = File.split(self.source)
    @file_name = file_info[1]
    @file_path = file_info[0]
    @file_extension = @file_name.split(".").last
    @file_name_short = @file_name.split(".")[0]
    @target = generate_string(creds)
    
    perform
    
  end
  
  def perform()
    puts "Uploading: #{@file_name}"
    puts "To: #{self.target}"
    Dir.chdir(@file_path)
    command =  'ovftool.exe' + ' --machineOutput --vCloudTemplate --acceptAllEulas --allowExtraConfig --noSSLVerify '+@file_name+' '+@target
    
    out =`#{command}`
    puts out
  end
  
  def probe
    puts "Getting OVF Info For #{self.source}"
    exec 'ovftool.exe', @source
  end
  
  
  def generate_string(creds)
  
    dest =  '"vcloud://'+creds[:user]+':'+creds[:pass]+'@'+creds[:url]+':443?org='+creds[:org]+'&catalog='+creds[:catalogue]
    if @file_extension == 'iso'
      dest = dest + '&media='+@file_name
    else
      dest = dest + '&vappTemplate='+@file_name_short+'&vapp='+@file_name_short+'&vdc='+creds[:vdc]
    end
    
    dest
      
  end
  
 end