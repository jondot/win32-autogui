require "win32/process"

module AutoGui

  class Application
    include AutoGui::Input

    attr_reader :path  
    attr_reader :name  
    attr_reader :title  
    attr_reader :main_window  
    
    @@titles = {}
    
    def initialize(name, options = {})
      @name = name
      @path = options[:path] || name
      @title = options[:title] || name

      # returns a struct
      Process.create(
         :app_name => name,
         :creation_flags => Process::DETACHED_PROCESS
      )

      @main_window = Window.find title
      Window::SetForegroundWindow(@main_window.handle) if running?
    end
    
    def close(options ={})
      @main_window.close
      wait_for_close = (options[:wait_for_close] == true) ? true : false
      if wait_for_close 
        timeout(5) do
          sleep 0.05 until 0 == Window::IsWindow(@main_window.handle)
        end
      end
    end

    def running?
      @main_window.handle != 0 && Window::IsWindow(@main_window.handle) != 0
    end
    

  private

  end

end