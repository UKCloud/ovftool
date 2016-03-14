require 'open3'
require 'thread'

class Ovftool
  attr_accessor :source, :target
  
  
  def initialize(creds)
    @config = creds
    self.source = creds[:source]
    file_info = File.split(self.source)
    @file_name = file_info[1]
    @file_path = file_info[0]
    @file_extension = @file_name.split(".").last
    @file_name_short = @file_name.split(".")[0]
    @pass = creds[:pass]
  end
  
  def upload
    @target = generate_upload_string(@config)
    
    puts "Uploading: #{@file_name}"
    puts "To: #{self.target.gsub(@pass,'REDACTED')}"
    
    perform(@file_name,@target)
  end
  
  def download(vapp = @config[:vapp])
    @destination_dir = @config[:directory]
    @config[:vapp] = vapp
    @source = generate_download_string(@config)
    
    puts "Downloading: #{vapp} from #{@config[:vdc]}"
    puts "Download String: #{@source.gsub(@pass,'REDACTED')}"
    
    perform(@source, @destination_dir)
  end
  
  def download_many(vapp_list)
      max_threads = 5
    
    
      work_q = Queue.new
      vapp_list.map {|n| work_q.push(n)}
      workers = (1..max_threads).map do
        Thread.new do
          begin
            while vapp = work_q.pop(true)
              download(vapp)
            end
          rescue ThreadError
          end
        end
      end; "ok"
      workers.map(&:join); "ok"
    
  end
  
  def perform(source, destination)

    Dir.chdir(@file_path)
    command =  'ovftool.exe' + ' --vCloudTemplate --acceptAllEulas --allowExtraConfig --noSSLVerify '+source+' '+destination
    

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
  
  def generate_upload_string(creds)

    dest =  '"vcloud://'+creds[:user]+':'+creds[:pass]+'@'+creds[:url]+':443?org='+creds[:org]+'&catalog='+creds[:catalogue]
    if @file_extension == 'iso'
      dest = dest + '&media='+@file_name
    else
      dest = dest + '&vappTemplate='+@file_name_short+'&vapp='+@file_name_short+'&vdc='+creds[:vdc]
    end
    
    dest
      
  end
  
  def generate_download_string(creds)

    source =  '"vcloud://'+creds[:user]+':'+creds[:pass]+'@'+creds[:url]+':443?org='+creds[:org]+'&vapp='+creds[:vapp]+'&vdc='+creds[:vdc]+'"'
  end
  
  
 end