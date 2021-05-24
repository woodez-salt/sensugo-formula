{%- if grains['os_family'] == 'Debian' %}
  {%- set repo_file = 'https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh' %}  
{%- else %}
  {%- set repo_file = 'https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh' %}
{%- endif %}



install_repo:
  cmd.run:
    - name: "curl -s {{ repo_file }} | sudo bash"

sensu_agent_packages:
  pkg.installed:
    - name: sensu-go-agent

setup_agent:
  file.managed:
    - name: /etc/sensu/agent.yml
    - source: salt://sensu/agent/files/agent.yml

service.running:
  - name: sensu-agent
  - enable: True
  - full_restart: True
  - watch:
    - file: /etc/sensu/agent.yml

