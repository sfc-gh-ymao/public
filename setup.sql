-- ---------------------------------------------------- --
-- Roles and Streamlit apps                             --
-- ---------------------------------------------------- --
create or replace schema app_schema;

create or replace application role "User" comment='User role has access to the main app';
create or replace application role "Admin" comment='Admin role also has access to the admin app';

grant usage on schema app_schema to application role "User";
grant usage on schema app_schema to application role "Admin";

create streamlit app_schema.main_app FROM '/streamlit' MAIN_FILE = '/main_app.py' TITLE = 'Main App';
grant usage on streamlit app_schema.main_app to application role "User";
grant usage on streamlit app_schema.main_app to application role "Admin";

-- only Admin can access this app
create streamlit app_schema.admin_app FROM '/streamlit' MAIN_FILE = '/admin_app.py' TITLE = 'Admin Area';
grant usage on streamlit app_schema.admin_app to application role "Admin";

create streamlit app_schema.privilege_app FROM '/streamlit' MAIN_FILE = '/privilege_app.py' TITLE = 'Privilege Test';
grant usage on streamlit app_schema.privilege_app to application role "User";
grant usage on streamlit app_schema.privilege_app to application role "Admin";

create streamlit app_schema.binding_app FROM '/streamlit' MAIN_FILE = '/binding_app.py' TITLE = 'Binding Test';
grant usage on streamlit app_schema.binding_app to application role "User";
grant usage on streamlit app_schema.binding_app to application role "Admin";


-- ---------------------------------------------------- --
-- For apps with bindings: (binding_app.py)             --
-- ---------------------------------------------------- --
create or alter versioned schema config;
grant usage on schema config to application role "User";
grant usage on schema config to application role "Admin";

create procedure config.table_to_consume_callback(ref_name string, operation string, ref_or_alias string)
  returns string
  language sql
  as $$
    begin
    case (operation)
        when 'ADD' then
          select system$add_reference(:ref_name, :ref_or_alias);
        when 'REMOVE' then
          select system$remove_reference(:ref_name, :ref_or_alias);
        when 'CLEAR' then
          select system$remove_all_references(:ref_name);
        else
          return 'Unknown operation: ' || operation;
    end case;
    return 'Operation ' || operation || ' succeeds.';
    end;
  $$;

grant usage on procedure config.table_to_consume_callback(string, string, string) 
  to application role "User";
grant usage on procedure config.table_to_consume_callback(string, string, string) 
  to application role "Admin";
