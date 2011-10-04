DIGGER: Ruby wrapper for DIG reasoner protocol
==============================================

Usage
-----

First, an instance of the reasoner interface must be initialized. Then you should initialize a new knowledge base. You will use the ID of the knowledge base to query that base.

    reasoner = Digger::Reasoner.new "localhost", 8081
    kb_id = reasoner.new_knowledge_base

If you want to log the debugging information that digger produces, you should assign a logger instance to Digger.logger:

    require "logger"
    Digger.logger = Logger.new("log/digger.log")

To perform reasoning on the knowledge base, you need to upload it first to the remote reasoner:

    ontology = File.read("knowledge.owl")
    reasoner.upload(kb_id, ontology)

Note that the knowledge base must be in OWL format.

When you no longer need the knowledge base, you should "release" it:

    reasoner.release_knowledge_base(kb_id)

You can instantiate as many knowledge bases as you want. The list of all currently instantiated (and not released) knowledge bases is accessible via *knowledge_bases* attribute:

    kb_ids = reasoner.knowledge_bases

Query the information about the capabilities of the remote reasoner:

    reasoner.info

Additionally, reasoner has some low-level information: host and port that it was initialized with and a latest response, accessible as "response" attribute.

You should refer to DIG/1.1 interface specification for a comprehensive list of DIG commands. Listed below is only a few examples.

A generic ASK query:

    reasoner.ask(kb_id, "<allConceptNames/>")

Other common queries are wrapped into corresponding methods: all_individuals, ancestors, all_role_names, etc. Please refer to "reasoner.rb" or RDoc documentation on Digger::Reasoner for more information.

All queries produce arrays of strings (class names) as output. Digger does not wrap and rescue Net exceptions, so you should handle them by yourself. You should check "reasoner.response.code_type" before accessing the output of digger for network errors (reasoner.response.code_type != Net::HTTPOK).

Also, all queries accept HTTP options (currently, only :read_timeout is supported):

    reasoner.parents(kb_id, "ns:Human", :read_timeout => 200)

Reasoners
---------

Digger was tested with the following reasoners:
  * Pellet
  * FaCT++

DIG specification
-----------------
Digger follows the specifications described in 'The DIG Description Logic Interface: DIG/1.1' book (dated February 7, 2003).
