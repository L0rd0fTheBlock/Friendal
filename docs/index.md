{% for file in site.static_files %}
{% if file.extname == ".md" %}
[{{ file.basename }}]({{site.baseurl}}/{{file.basename}}.html)
{% endif %}
{% endfor %}

#Welcome to the Palendar documentation!

Here you will find everything you could possibly want to know about Friendal.

Friendal is currently in a pre-beta state which means everything you read here is subject to change. Please keep in mind that there may be a delay between changed being implemented and this wiki being updated.

Thanks
