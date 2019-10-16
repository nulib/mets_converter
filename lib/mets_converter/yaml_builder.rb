require_relative '../indent'
require 'pry'

module MetsConverter
  class YamlBuilder

    attr_reader :document, :pages, :options

    def initialize(mets, **options)
      @document = mets.document
      @pages = mets.pages
      @options = options
    end

    def build
      # Descriptive and technical information

      # Capture Date
      #   <metsHdr CREATEDATE="2015-07-01T15:26:39" RECORDSTATUS="Complete">
      yaml = "capture_date: #{document.xpath("//xmlns:metsHdr")[0].attr("CREATEDATE")}-06:00\n"
      # Scanner Make and Model
      if options[:suprascan]
        yaml += "scanner_make: SupraScan\n"
        yaml += "scanner_model: Quartz A1\n"
      else
        yaml += "scanner_make: Kirtas\n"
        yaml += "scanner_model: APT 1200\n"
      end
      # Scanner User
      yaml += "scanner_user: \"Northwestern University Library: Repository & Digital Curation\"\n"
      # Resolution
      yaml += "contone_resolution_dpi: #{options[:resolution] || 300}\n"
      # Image Compression Date
      yaml += "image_compression_date: #{document.xpath("//xmlns:metsHdr")[0].attr("CREATEDATE")}-06:00\n"
      # Image Compression Agent
      yaml += "image_compression_agent: northwestern\n"
      # Image Compression Tool
      yaml += "image_compression_tool: [\"LIMB v3.1.0.0\"]\n"
      # Scanning Order
      if options[:scanning_order_rtl]
        yaml += "scanning_order: right-to-left\n"
      else
        yaml += "scanning_order: left-to-right\n"
      end
      # Reading Order
      if options[:reading_order_rtl]
        yaml += "reading_order: right-to-left\n"
      else
        yaml += "reading_order: left-to-right\n"
        yaml += "pagedata:\n"
      end

      # File List

      # Loop through pages within logical structMap
      pages.each do |element|
        # Store the fileid for the jp2
        file_id = element.xpath('./xmlns:fptr[starts-with(@FILEID, "JP2")]')[0]["FILEID"]
        # Store the jp2 filename
        filename = find_filename_by_file_id(file_id)
        # Since the yaml flattens out the xml structure,
        # the first child of each parent gets special treatment (of course)
        # i.e. labels for covers, titles, chapters, etc.
        if element == element.parent.first_element_child
          case
          when element.parent["LABEL"] == "Cover" && element.parent["TYPE"] == "cover" && element.parent == document.search('structMap[@TYPE="logical"]//div[@TYPE="cover"]').first
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"FRONT_COVER\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"FRONT_COVER\" }\n"
            end
          when element.parent["LABEL"] == "Front Matter"
            next if element["ORDERLABEL"].empty?
            line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\" }\n"
          when element.parent["LABEL"] == "Cover" && element.parent["TYPE"] == "appendix"
            next if element["ORDERLABEL"].empty?
            line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\" }\n"
          when element.parent["LABEL"] == "Title"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"TITLE\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"TITLE\" }\n"
            end
          when element.parent["LABEL"] == "Contents"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"TABLE_OF_CONTENTS\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"TABLE_OF_CONTENTS\" }\n"
            end
          when element.parent["LABEL"] == "Preface"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"PREFACE\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"PREFACE\" }\n" 
            end
          # First page within the body, can be within a div with label attribute "Introduction" or "Chapter"
          when element == document.at('structMap[@TYPE="logical"]//div[@TYPE="body"]/div[1]/div[1]') && (element.parent["LABEL"] == "Introduction" || element.parent["LABEL"].start_with?("Chapter"))
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"FIRST_CONTENT_CHAPTER_START\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"FIRST_CONTENT_CHAPTER_START\" }\n"
            end
          when element.parent["LABEL"] == "Back Matter"
            next if element["ORDERLABEL"].empty?
            line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\" }\n"
          when element.parent["LABEL"].start_with?("Chapter") || element.parent["LABEL"] == "Appendix"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"CHAPTER_START\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"CHAPTER_START\" }\n"
            end
          when element.parent["LABEL"] == "Notes" || element.parent["LABEL"] == "Bibliography"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"REFERENCES\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"REFERENCES\" }\n"
            end
          when element.parent["LABEL"] == "Index"
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"INDEX\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"INDEX\" }\n"
            end
          when element.parent["LABEL"] == "Cover" && element.parent["TYPE"] == "cover" && element.parent == document.search('structMap[@TYPE="logical"]//div[@TYPE="cover"]').last
            if element["ORDERLABEL"].empty?
              line = filename + ": { label: \"BACK_COVER\" }\n"
            else
              line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\", label: \"BACK_COVER\" }\n"
            end
          end
        else
          # remaining pages
          # skip pages that don't have page numbers (stored in "ORDERLABEL" attribute)
          next if element["ORDERLABEL"].empty?
          line = filename + ": { orderlabel: \"#{element["ORDERLABEL"]}\" }\n"
        end
        yaml += line.indent(4) if line
      end

      yaml
    end

    def find_filename_by_file_id(id)
      document.xpath("//xmlns:file[@ID=\"#{id}\"]/xmlns:FLocat")[0]['xlink:href'][7..-1]
    end
  end
end