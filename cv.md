---
layout: page
title: CV
permalink: /cv/
---

I'm a software engineer, working primarily with embedded systems, and I have a
passion for functional programming. I believe in free and open source software,
and I try to contribute to it as much as I can.

I also enjoy playing rhythm-based games whenever I can, such as Dance Dance
Revolution, Beatmania IIDX and similar games. Timing is everything.

## Software skills

I can program in more or less any language, I’ve sampled most different
paradigms. Languages I have most experience with are C++, Python, Haskell, Java,
Bash, Erlang. Professionally I have mostly written C++, Python, Bash and QML.

I feel at home in a small team of experts, preferrably following some agile
setting. I work exclusively in GNU/Linux environments. I don't like Windows, but
I can use it if I must. I'm a dvorak typist since 2008. I'm a native swede and
speak english fluently.

----------------

## Personal

* **Date of birth:** 1988-07-30
* **E-mail:** tobsan[at]tobsan[dot]se (GPG key fingerprint: `1EEF 527E 9341 888C 6D32  61D8 227C A2A2 FF16 BE40`)
* **[GitHub profile](https://github.com/tobsan)**

----------------

## Work experience
{% for item in site.data.cv %}
{% if item.employer %}
### {{ item.employer }}
{{ item.description }}

#### Duration
{{ item.start }} - {{ item.end }}

#### Position
{{ item.position }}

{% endif %}
{% endfor %}

----------------

## Education
{% for item in site.data.cv %}
{% if item.programme %}
### {{ item.programme }}
{{ item.description }}

#### Duration
{{ item.begin }} - {{ item.end }}

{% endif %}
{% endfor %}

----------------

## Misc
I have a european type B driving license. I prefer commuting through public transport though.

