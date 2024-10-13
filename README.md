# An Example Native App

This is an example native app containing several example streamlit apps inside.

## Streamlit apps

- `main_app.py`: the example streamlit app
- `admin_app.py`: an example admin app which can only be accessed with app role `Admin`
- `privilege_app.py`: app with some account level privilege request
- `binding_app.py`: test the external bindings

# Developing

If you would like to create an app from scratch:

## Instructions

- Download this repo [here](https://github.com/snowflakedb/native-app/archive/refs/heads/main.zip) and unzip it
- Open Snowsight and navigate to `Data -> Databases`
- Create a database if you don't have any to choose, for example: `test_db`
- Select the database, and then create a schema if you don't have other choice, such as: `test_schema`
- Select the schema. Click the `Create` dropdown on the topright and then `Stage -> Snowflake Managed`
- Name your stage like `test_stage`. Keep the `Enable dictory table` option on. Click `Create`
- Select the newly created stage, and click `+ Files` and upload those files to the root folder:
  - `manifest.yml`
  - `README.md`
  - `setup.sql`
- Click `+ Files` again, and choose all the files inside `streamlit` folder to upload. Specify the target folder `streamlit`. click `Upload`
- Navigate to `Apps`, select `Packages` tab
- Click `+ Add package` button and name the package like `streamlit_package`. Create the app package.
- Click `Add first version`, choose a version name like `v1`, select the database and stage we were using. Click `Create`
- `Set as default version patch` if necessary
- Publish the package or test the package locally

## Install the app locally

To install the app locally from the app package we created in the above steps without creating a listing:

```sql
create application my_test_app from application package streamlit_package using version v1;
```

You will be able to see the app listed in the `Apps` IA tab.


## Make changes

You may make any changes to the downloaded files and upload them again, or you could simply clicking [this link](https://github.com/snowflakedb/native-app/generate) to start editing your new app in GitHub.
