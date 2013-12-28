Pod::Spec.new do |s|

  s.name         = "SQLiteManager"
  s.version      = "0.1"
  s.summary      = "一个线程安全的Sqlite工具"
  s.description  = <<-DESC
                   *一个线程安全的Sqlite工具
                   DESC

  s.homepage     = "http://ibcker.me"
  s.license      = 'Apache'
  s.author       = { "ibcker" => "happymiyu@gmail.com" }
  s.source       = { :git => "https://github.com/iBcker/SQLiteManager.git", :tag => "0.1" }
  s.source_files  = 'Classes', 'SQLiteManager/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true
end
