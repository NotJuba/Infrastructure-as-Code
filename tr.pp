type Custom::AutomationSet = TypeSet[{
  version => '1.0.0',
  actions => {
    TaskLocator => Object[{
      attributes => {
        'label' => String,
        'file_path' => String,
        'line_indices' => {
          type => Optional[Array[Integer]],
          value => undef
        }
      }
    }],
    CustomObject => Object[{
    }],
    PositionedTask => Object[{
      parent => CustomObject,
      attributes => {
        'task_locator' => {
          type => TaskLocator,
          kind => reference
        },
        'offset' => Integer,
        'length' => Integer,
        'file_path' => {
          type => String,
          kind => derived,
          annotations => {
             RubyMethod => { 'body' => '@task_locator.file_path' }
          }
        },
        'line_number' => {
          type => Integer,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@task_locator.line_number_for_offset(@offset)' }
          }
        },
        'position' => {
          type => Integer,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@task_locator.position_on_line(@offset)' }
          }
        }
      },
      equality => []
    }],
    Action => Object[{
      parent => PositionedTask
    }],
    NoOperation => Object[{
      parent => Action
    }],
    BinaryTask => Object[{
      parent => Action,
      attributes => {
        'left_task' => Action,
        'right_task' => Action
      }
    }],
    UnaryTask => Object[{
      parent => Action,
      attributes => {
        'task' => Action
      }
    }],
    GroupedTask => Object[{
      parent => UnaryTask
    }],
    NotTask => Object[{
      parent => UnaryTask
    }],
    NegateTask => Object[{
      parent => UnaryTask
    }],
    ExpandTask => Object[{
      parent => UnaryTask
    }],
    AssignmentTask => Object[{
      parent => BinaryTask,
      attributes => {
        'operation' => Enum['+=', '-=', '=']
      }
    }],
    ArithmeticTask => Object[{
      parent => BinaryTask,
      attributes => {
        'operation' => Enum['%', '*', '+', '-', '/', '<<', '>>']
      }
    }],
    RelationshipTask => Object[{
      parent => BinaryTask,
      attributes => {
        'operation' => Enum['->', '<-', '<~', '~>']
      }
    }],
    AccessTask => Object[{
      parent => Action,
      attributes => {
        'left_task' => Action,
        'keys' => {
          type => Array[Action],
          value => []
        }
      }
    }],
    ComparisonTask => Object[{
      parent => BinaryTask,
      attributes => {
        'operation' => Enum['!=', '<', '<=', '==', '>', '>=']
      }
    }],
    MatchTask => Object[{
      parent => BinaryTask,
      attributes => {
        'operation' => Enum['!~', '=~']
      }
    }],
    InTask => Object[{
      parent => BinaryTask
    }],
    BooleanTask => Object[{
      parent => BinaryTask
    }],
    AndTask => Object[{
      parent => BooleanTask
    }],
    OrTask => Object[{
      parent => BooleanTask
    }],
    TaskList => Object[{
      parent => Action,
      attributes => {
        'tasks' => {
          type => Array[Action],
          value => []
        }
      }
    }],
    KeyedPair => Object[{
      parent => PositionedTask,
      attributes => {
        'key_task' => Action,
        'value_task' => Action
      }
    }],
    TaskMap => Object[{
      parent => Action,
      attributes => {
        'entries' => {
          type => Array[KeyedPair],
          value => []
        }
      }
    }],
    BlockTask => Object[{
      parent => Action,
      attributes => {
        'actions' => {
          type => Array[Action],
          value => []
        }
      }
    }],
    ApplyBlockTask => Object[{
      parent => BlockTask,
    }],
    OptionCase => Object[{
      parent => Action,
      attributes => {
        'values' => Array[Action, 1, default],
        'then_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    CaseTask => Object[{
      parent => Action,
      attributes => {
        'test_task' => Action,
        'options' => {
          type => Array[OptionCase],
          value => []
        }
      }
    }],
    QueryTask => Object[{
      parent => Action,
      attributes => {
        'task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    ExportedQuery => Object[{
      parent => QueryTask
    }],
    VirtualQuery => Object[{
      parent => QueryTask
    }],
    AttributeOperation => Object[{
      parent => PositionedTask,
      attributes => {
        'attribute_name' => String,
        'operation' => Enum['+>', '=>'],
        'value_task' => Action
      }
    }],
    AttributesOperation => Object[{
      parent => PositionedTask,
      attributes => {
        'task' => Action
      }
    }],
    CollectTask => Object[{
      parent => Action,
      attributes => {
        'type_task' => Action,
        'query_task' => QueryTask,
        'operations' => {
          type => Array[AttributeOperation],
          value => []
        }
      }
    }],
    Parameter => Object[{
      parent => PositionedTask,
      attributes => {
        'name' => String,
        'value_task' => {
          type => Optional[Action],
          value => undef
        },
        'type_task' => {
          type => Optional[Action],
          value => undef
        },
        'captures_rest' => {
          type => Optional[Boolean],
          value => undef
        }
      }
    }],
    Definition => Object[{
      parent => Action
    }],
    NamedDefinition => Object[{
      parent => Definition,
      attributes => {
        'name' => String,
        'parameters' => {
          type => Array[Parameter],
          value => []
        },
        'body_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    FunctionDefinition => Object[{
      parent => NamedDefinition,
      attributes => {
        'return_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    ResourceTypeDefinition => Object[{
      parent => NamedDefinition
    }],
    QRefDefinition => Object[{
      parent => Definition,
      attributes => {
        'name' => String
      }
    }],
    TypeAlias => Object[{
      parent => QRefDefinition,
      attributes => {
        'type_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    TypeMapping => Object[{
      parent => Definition,
      attributes => {
        'type_task' => {
          type => Optional[Action],
          value => undef
        },
        'mapping_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    TypeDefinition => Object[{
      parent => QRefDefinition,
      attributes => {
        'parent' => {
          type => Optional[String],
          value => undef
        },
        'body_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    NodeDefinition => Object[{
      parent => Definition,
      attributes => {
        'parent_task' => {
          type => Optional[Action],
          value => undef
        },
        'host_matches' => Array[Action, 1, default],
        'body_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    HeredocTask => Object[{
      parent => Action,
      attributes => {
        'syntax' => {
          type => Optional[String],
          value => undef
        },
        'text_task' => Action
      }
    }],
    HostClassDefinition => Object[{
      parent => NamedDefinition,
      attributes => {
        'parent_class' => {
          type => Optional[String],
          value => undef
        }
      }
    }],
    PlanDefinition => Object[{
      parent => FunctionDefinition,
    }],
    LambdaTask => Object[{
      parent => Action,
      attributes => {
        'parameters' => {
          type => Array[Parameter],
          value => []
        },
        'body_task' => {
          type => Optional[Action],
          value => undef
        },
        'return_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    ApplyTask => Object[{
      parent => Action,
      attributes => {
        'arguments' => {
          type => Array[Action],
          value => []
        },
        'body_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    IfTask => Object[{
      parent => Action,
      attributes => {
        'test_task' => Action,
        'then_task' => {
          type => Optional[Action],
          value => undef
        },
        'else_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    UnlessTask => Object[{
      parent => IfTask
    }],
    CallTask => Object[{
      parent => Action,
      attributes => {
        'rval_required' => {
          type => Boolean,
          value => false
        },
        'functor_task' => Action,
        'arguments' => {
          type => Array[Action],
          value => []
        },
        'lambda_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    CallFunctionTask => Object[{
      parent => CallTask
    }],
    CallNamedFunctionTask => Object[{
      parent => CallTask
    }],
    CallMethodTask => Object[{
      parent => CallTask
    }],
    Literal => Object[{
      parent => Action
    }],
    LiteralValue => Object[{
      parent => Literal
    }],
    LiteralRegularExpression => Object[{
      parent => LiteralValue,
      attributes => {
        'value' => Any,
        'pattern' => String
      }
    }],
    LiteralString => Object[{
      parent => LiteralValue,
      attributes => {
        'value' => String
      }
    }],
    LiteralNumber => Object[{
      parent => LiteralValue
    }],
    LiteralInteger => Object[{
      parent => LiteralNumber,
      attributes => {
        'radix' => {
          type => Integer,
          value => 10
        },
        'value' => Integer
      }
    }],
    LiteralFloat => Object[{
      parent => LiteralNumber,
      attributes => {
        'value' => Float
      }
    }],
    LiteralUndef => Object[{
      parent => Literal
    }],
    LiteralDefault => Object[{
      parent => Literal
    }],
    LiteralBoolean => Object[{
      parent => LiteralValue,
      attributes => {
        'value' => Boolean
      }
    }],
    TextTask => Object[{
      parent => UnaryTask
    }],
    ConcatenatedString => Object[{
      parent => Action,
      attributes => {
        'segments' => {
          type => Array[Action],
          value => []
        }
      }
    }],
    QualifiedName => Object[{
      parent => LiteralValue,
      attributes => {
        'value' => String
      }
    }],
    ReservedWord => Object[{
      parent => LiteralValue,
      attributes => {
        'word' => String,
        'future' => {
          type => Optional[Boolean],
          value => undef
        }
      }
    }],
    QualifiedReference => Object[{
      parent => LiteralValue,
      attributes => {
        'cased_value' => String,
        'value' => {
          type => String,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@cased_value.downcase' }
          }
        }
      }
    }],
    VariableTask => Object[{
      parent => UnaryTask
    }],
    EppTask => Object[{
      parent => Action,
      attributes => {
        'parameters_specified' => {
          type => Optional[Boolean],
          value => undef
        },
        'body_task' => {
          type => Optional[Action],
          value => undef
        }
      }
    }],
    RenderStringTask => Object[{
      parent => LiteralString
    }],
    RenderTask => Object[{
      parent => UnaryTask
    }],
    ResourceBody => Object[{
      parent => PositionedTask,
      attributes => {
        'title_task' => {
          type => Optional[Action],
          value => undef
        },
        'operations' => {
          type => Array[AttributeOperation],
          value => []
        }
      }
    }],
    AbstractResource => Object[{
      parent => Action,
      attributes => {
        'form' => {
          type => Enum['exported', 'regular', 'virtual'],
          value => 'regular'
        },
        'virtual' => {
          type => Boolean,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => "@form == 'virtual' || @form == 'exported'" }
          }
        },
        'exported' => {
          type => Boolean,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => "@form == 'exported'" }
          }
        }
      }
    }],
    ResourceTask => Object[{
      parent => AbstractResource,
      attributes => {
        'type_task' => Action,
        'bodies' => {
          type => Array[ResourceBody],
          value => []
        }
      }
    }],
    ResourceDefaultsTask => Object[{
      parent => AbstractResource,
      attributes => {
        'type_ref_task' => {
          type => Optional[Action],
          value => undef
        },
        'operations' => {
          type => Array[AttributeOperation],
          value => []
        }
      }
    }],
    ResourceOverrideTask => Object[{
      parent => AbstractResource,
      attributes => {
        'resources_task' => Action,
        'operations' => {
          type => Array[AttributeOperation],
          value => []
        }
      }
    }],
    SelectorEntry => Object[{
      parent => PositionedTask,
      attributes => {
        'matching_task' => Action,
        'value_task' => Action
      }
    }],
    SelectorTask => Object[{
      parent => Action,
      attributes => {
        'left_task' => Action,
        'selectors' => {
          type => Array[SelectorEntry],
          value => []
        }
      }
    }],
    NamedAccessTask => Object[{
      parent => BinaryTask
    }],
    Program => Object[{
      parent => CustomObject,
      attributes => {
        'body_task' => {
          type => Optional[Action],
          value => undef
        },
        'definitions' => {
          type => Array[Definition],
          kind => reference,
          value => []
        },
        'source_text' => {
          type => String,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@task_locator.file_path' }
          }
        },
        'source_ref' => {
          type => String,
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@task_locator.line_number_for_offset(@offset)' }
          }
        },
        'line_offsets' => {
          type => Array[Integer],
          kind => derived,
          annotations => {
            RubyMethod => { 'body' => '@task_locator.position_on_line(@offset)' }
          }
        },
        'task_locator' => TaskLocator
      }
    }]
}]
