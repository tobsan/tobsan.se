---
layout: page
title: CV
permalink: /cv/
---

I'm a Swedish software engineer, working primarily with embedded systems, and I
have a passion for functional programming. I believe in free and open source
software, and I try to contribute to it, as well as using it, as much as I can.

I...
- program mostly in C, but inevitably write scripts in both Bash and Python
- work (almost) exclusively in GNU/Linux environments
- despise management-driven development methodologies like SAFe
- am a bit of a keyboard nerd, having fallen in love with the TypeMatrix 2030
- enjoy playing rhythm-based games whenever I can, mostly Dance Dance
  Revolution. Timing is everything.
- speak swedish and english fluently
- have a drivers license, EU type B

----------------

## Personal

* **Date of birth:** 1988-07-30
* **E-mail:** tobsan[at]tobsan[dot]se (GPG key fingerprint: `1EEF 527E 9341 888C 6D32  61D8 227C A2A2 FF16 BE40`)
* **[GitHub profile](https://github.com/tobsan)**

----------------

## Work experience
{% for item in site.data.cv %}

{% if item.visible == false %}
{% continue %}
{% endif %}

{% if item.employer %}
### {{ item.employer }}
**Duration:** {{ item.start }} - {{ item.end }} <br />
**Position:** {{ item.position }}

{{ item.description }}

----------------
{% endif %}
{% endfor %}

## Education
{% for item in site.data.cv %}

{% if item.visible == false %}
{% continue %}
{% endif %}

{% if item.programme %}
### {{ item.programme }} @ {{ item.where }}
**Duration:** {{ item.begin }} - {{ item.end }}

{{ item.description }}

{% endif %}
{% endfor %}
