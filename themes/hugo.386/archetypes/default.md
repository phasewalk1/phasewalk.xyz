---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
description: ""
tags: []
categories: []
---

{{ if or .Params.math .Site.Params.math }}
{{ partial "math.html" . }}
{{ end }}
