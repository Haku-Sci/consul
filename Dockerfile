FROM hashicorp/consul:1.20.3

EXPOSE 8500

CMD ["agent", "-dev", "-client", "0.0.0.0"]
