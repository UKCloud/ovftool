require 'open3'
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
    puts "To: #{self.target.gsub(@pass,'REDACTED')}"
    Dir.chdir(@file_path)
    command =  'ovftool.exe' + ' --vCloudTemplate --acceptAllEulas --allowExtraConfig --noSSLVerify '+@file_name+' '+@target
    
    #out =`#{command}`
    #puts out
    
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|

      until stdout.closed? do
        
        stdout.each do |line|
          if line.match(/Progress:/) then
            line = line.chomp
            print "\r#{line}"
          else
            print line
          end
        end  
        return if wait_thr.value.exited?
      end
      
    end
  end
  
  def probe
    puts "Getting OVF Info For #{self.source}"
    exec 'ovftool.exe', @source
  end
  
  def check_pid(pid)
    begin
      Process.getpgid( pid )
      true
    rescue Errno::ESRCH
      false
    end

  end
  
  def generate_string(creds)
    @pass = creds[:pass]
    dest =  '"vcloud://'+creds[:user]+':'+creds[:pass]+'@'+creds[:url]+':443?org='+creds[:org]+'&catalog='+creds[:catalogue]
    if @file_extension == 'iso'
      dest = dest + '&media='+@file_name
    else
      dest = dest + '&vappTemplate='+@file_name_short+'&vapp='+@file_name_short+'&vdc='+creds[:vdc]
    end
    
    dest
      
  end
  
 end