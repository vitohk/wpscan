module Report
  @@report = nil
  def self.report=(report)
    @@report = report
  end

  def self.report
    @@report
  end

  def self.add_vuln(title, desc = '', fixed_in = '')
    return unless report
    vuln_item = VulnItem.new title, desc, fixed_in
    JsonReport.add(vuln_item, report)
  end

  def self.add_info(title, desc = '')
    return unless report
    info_item = InfoItem.new title, desc
    JsonReport.add(info_item, report)
  end

  def self.add_error(title, desc = '')
    return unless report
    error_item = ErrorItem.new title, desc
    JsonReport.add(error_item, report)
  end

  def self.add_leak(title, desc = '')
    return unless report
    leak_item = LeakItem.new title, desc
    JsonReport.add(leak_item, report)
  end
end
class JsonReport
  def initialize
    @infos = []
    @leaks = []
    @vulns = []
    @errors = []
  end
  attr_reader :infos, :leaks, :vulns, :errors
  def self.add(item, json_report)
    case item.item_type
    when :info
      json_report.infos << item
    when :leak
      json_report.leaks << item
    when :vuln
      json_report.vulns << item
    when :error
      json_report.errors << item
    end
  end

  def self.add_if_needed(item, json_report)
    return unless json_report
    add(item, json_report)
  end

  def to_json(*a)
    {
      'infos' => @infos,
      'leaks'    => @leaks,
      'vulns'    => @vulns,
      'errors'   => @errors
    }.to_json(*a)
  end
end
class ReportItem
  ITEM_TYPES = %i(
    info
    leak
    vuln
    error
  ).freeze
  def initialize(title, item_type, desc)
    raise 'A title is mandatory' unless title
    raise 'Title must be a string' unless title.is_a? String
    raise 'A item_type is mandatory' unless item_type
    raise "The only allowed item_types are #{ITEM_TYPES}" unless ITEM_TYPES.include? item_type
    @item_type = item_type
    @title = title
    @desc  = desc
    end
  attr_reader :item_type, :title, :desc
  def to_json(*a)
    {
      'title' => @title,
      'item_type' => @item_type,
      'desc' => @desc
    }.to_json(*a)
  end
end
class VulnItem < ReportItem
  def initialize(title, desc, fixed_in)
    super(title, :vuln, desc)
    @fixed_in = fixed_in
  end

  def to_json(*a)
    {
      'title' => @title,
      'item_type' => @item_type,
      'desc' => @desc,
      'fixed_in' => @fixed_in
    }.to_json(*a)
  end
end
class InfoItem < ReportItem
  def initialize(title, desc = '')
    super(title, :info, desc)
  end
end
class LeakItem < ReportItem
  def initialize(title, desc = '')
    super(title, :leak, desc)
  end
end
class ErrorItem < ReportItem
  def initialize(title, desc = '')
    super(title, :error, desc)
  end
end
