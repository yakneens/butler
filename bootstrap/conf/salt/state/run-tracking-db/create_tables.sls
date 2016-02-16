create_sample_locations_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE sample_locations (sample_location_id serial PRIMARY KEY, donor_index integer REFERENCES pcawg_samples(index), normal_sample_location varchar(512), tumor_sample_location varchar(512), last_updated timestamp)"

create_config_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE configuration(config_id uuid PRIMARY KEY, config jsonb, created_date timestamp, last_updated_date timestamp)"

create_analysis_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE analysis (analysis_id serial PRIMARY KEY, config_id uuid REFERENCES configuration(config_id), analysis_name varchar(255), start_date timestamp, created_date timestamp, last_updated_date timestamp)"

create_workflow_default_config_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE workflow(workflow_id serial PRIMARY KEY, workflow_name varchar(255), workflow_version varchar(255), config_id uuid REFERENCES configuration(config_id), created_date timestamp, last_updated_date timestamp)"


create_runs_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE analysis_run (analysis_run_id serial PRIMARY KEY, analysis_id serial REFERENCES analysis(analysis_id), config_id uuid REFERENCES configuration(config_id), run_status integer NOT NULL, workflow_id serial REFERENCES workflow(workflow_id), created_date timestamp, run_start_date timestamp, run_end_date timestamp, last_updated_date timestamp, run_error_code integer)"

