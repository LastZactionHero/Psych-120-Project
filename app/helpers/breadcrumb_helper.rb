module BreadcrumbHelper
    
  # Generate Bread crumb HTML from path
  # From: http://www.onlineaspect.com/2010/06/19/breadcrumbs-in-rails/
  def get_bread_crumb(url)
      begin
          breadcrumb = ''
          so_far = '/'
          elements = url.split('/')
          for i in 1...elements.size
          
              so_far += elements[i] + '/'
              
              if elements[i] =~ /^\d+$/
                  begin
                      breadcrumb += link_to_if(i != elements.size - 1, eval("#{elements[i - 1].singularize.camelize}.find(#{elements[i]}).name").gsub("_"," ").to_s, so_far)
                  rescue
                      breadcrumb += elements[i]
                  end
              else
                  breadcrumb += link_to_if(i != elements.size - 1,elements[i].gsub("_"," ").titleize, so_far)
              end
              
              breadcrumb += " > " if i != elements.size - 1
          end
          breadcrumb
      rescue
          'Not available'
      end
  end
  
end