Puppet::Type.newtype(:cs_commit) do
  @doc = 'This type is an implementation detail. DO NOT use it directly'

  feature :refreshable, 'The provider can execute the commit.', :methods => [:commit]

  newparam(:cib) do
    def insync?(_is)
      true
    end

    defaultto { @resource[:name] }
  end

  newparam(:name) do
    isnamevar
  end

  def refresh
    provider.commit
  end

  autorequire(:service) do
    ['corosync']
  end

  autorequire(:cs_shadow) do
    [@parameters[:cib]]
  end

  if Puppet::Util::Package.versioncmp(Puppet::PUPPETVERSION, '4.0') < 0
    autorequire(:cs_primitive) do
      resources_with_cib :cs_primitive
    end

    autorequire(:cs_property) do
      resources_with_cib :cs_property
    end

    autorequire(:cs_colocation) do
      resources_with_cib :cs_colocation
    end

    autorequire(:cs_location) do
      resources_with_cib :cs_location
    end

    autorequire(:cs_group) do
      resources_with_cib :cs_group
    end

    autorequire(:cs_order) do
      resources_with_cib :cs_order
    end
  else
    autosubscribe(:cs_primitive) do
      resources_with_cib :cs_primitive
    end

    autosubscribe(:cs_property) do
      resources_with_cib :cs_property
    end

    autosubscribe(:cs_colocation) do
      resources_with_cib :cs_colocation
    end

    autosubscribe(:cs_location) do
      resources_with_cib :cs_location
    end

    autosubscribe(:cs_group) do
      resources_with_cib :cs_group
    end

    autosubscribe(:cs_order) do
      resources_with_cib :cs_order
    end
  end

  def resources_with_cib(cib)
    autos = []
    # rubocop:disable Lint/UselessAssignment
    catalog.resources.find_all { |r| r.is_a?(Puppet::Type.type(cib)) && param = r.parameter(:cib) && !param.nil? && param.value == @parameters[:cib] }.each do |r|
      # rubocop:enable Lint/UselessAssignment
      autos << r
    end

    autos
  end
end
