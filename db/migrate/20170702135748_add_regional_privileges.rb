class AddRegionalPrivileges < ActiveRecord::Migration[5.1]
  def up
    Privilege.create(slug: 'region_manager', name: 'Управляющий регионом', regional: true)
    PrivilegeGroup.create(slug: 'region_managers', name: 'Управляющие регионами')

    group = PrivilegeGroup.find_by(slug: 'region_managers')
    group.add_privilege(Privilege.find_by(slug: 'administrator'))
    group.add_privilege(Privilege.find_by(slug: 'region_manager'))
  end

  def down
    PrivilegeGroup.where(slug: 'region_managers').delete_all
    Privilege.where(slug: 'region_manager').delete_all
  end
end
