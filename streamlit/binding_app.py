import streamlit as st
import snowflake.permissions as permission
from snowflake.snowpark.context import get_active_session

st.title("This is the binding example")

@st.cache_data
def load_data():
    sql = "SELECT * from reference('table_to_consume')"
    st.write(f"Data from the reference `table_to_consume`:")
    return get_active_session().sql(sql).collect()

reference_associations = permission.get_reference_associations("table_to_consume")
if len(reference_associations) == 0:
    st.write("Please choose a table to query")
    permission.request_reference("table_to_consume")
else:
    with st.expander("View Table Data"):
        df = load_data()
        st.dataframe(df)

