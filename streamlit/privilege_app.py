import streamlit as st
import snowflake.permissions as permission
from snowflake.snowpark.context import get_active_session


st.title("This is the app with account level privilege request")

missing_privileges = permission.get_missing_account_privileges(["CREATE DATABASE"])
if len(missing_privileges) > 0:
    permission.request_account_privileges(missing_privileges)
    st.write("Please grant the privilege request")
    st.stop()

session = get_active_session()

name = st.text_input('Database name', 'TESTDB')

if st.button('Create Database and Populate Data'):
    with st.spinner(f'Creating database {name}'):
        result = session.sql(f'CREATE OR REPLACE DATABASE "{name}"').collect()
        result
        result = session.sql(f'CREATE OR REPLACE TABLE "{name}".PUBLIC.employees (\
  first_name varchar(100) not null,\
  last_name varchar(100) not null,\
  phone varchar(20) not null,\
  city varchar(20) not null,\
  zip_code integer not null);').collect()
        result
        result = session.sql(f"INSERT INTO \"{name}\".PUBLIC.employees VALUES \
  ('Lysandra\','Reeves','1-212-759-3751','New York',10018),\
  ('May','Franklin','1-650-249-5198','San Francisco',94115),\
  ('Gillian','Patterson','1-650-859-3954','San Francisco',94115),\
  ('Michael','Arnett','1-650-230-8467','San Francisco',94116);").collect()
        result
    st.success('Done!')
