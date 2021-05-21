---
layout: page
title: Links
permalink: /stuff/
---

This page is part bragging, part just a stash of things that won't fit the blogging part. The list
below is sorted alphabetically.

{% assign links_grouped = site.data.links | group_by: 'category' | sort: 'name' %}
{% for group in links_grouped %}
### {{ group.name | capitalize }}
{% assign items = group.items | sort: 'title' %}
{% for item in items %}
{% if item.title %}
* [{{ item.title }}]({{ item.url }}) - {{ item.description }}
{% else %}
* [{{ item.description }}]({{ item.url }}).
{% endif %}
{% endfor %}
{% endfor %}
