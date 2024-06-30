- name: Create individual files with secret data
  vars:
    secret_json_string: "{{ mtls_secret_data[mtls_secret_name] | from_json }}"
    secret_files:
      - name: ca_certificate
        path: "{{ mtls_key_dir }}/ca.cer"
        secret_key: ca_certificate
      - name: attestor_certificate
        path: "{{ mtls_key_dir }}/attestor1.crt"
        secret_key: attestor_certificate
      - name: attestor_key
        path: "{{ mtls_key_dir }}/attestor1.key"
        secret_key: attestor_key
  loop: "{{ secret_files }}"
  ansible.builtin.copy:
    content: "{{ secret_json_string[item.secret_key] }}"
    dest: "{{ item.path }}"
    check_mode: no  # Skip checking if the file needs to be copied
  register: copy_results
  async: 60  # Execute asynchronously with a timeout of 60 seconds
  poll: 0  # Immediately move on to the next task without waiting for the async task to complete
  tags:
    - create_secret_files

- name: Wait for async copy tasks to complete
  async_status:
    jid: "{{ item.ansible_job_id }}"
  register: async_result
  until: async_result.finished
  retries: 30
  delay: 5
  loop: "{{ copy_results.results }}"
  when: copy_results is defined

- name: Debug async task results
  debug:
    msg: "Async task result: {{ item }}"
  loop: "{{ copy_results.results }}"
  when: copy_results is defined

