package jp.ac.nii.prg.bxauthz.tests

import jp.ac.nii.prg.bxauthz.BxAuthZInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import jp.ac.nii.prg.bxauthz.bxAuthZ.Model
import org.junit.Test

@InjectWith(BxAuthZInjectorProvider)
@RunWith(XtextRunner)

class ParserTest {
	@Inject extension ParseHelper<Model> parser
	@Inject extension ValidationTestHelper
	
	@Test
	def testEmptyPolicy() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testOneSimpleRule() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPath() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar//test
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathStartWithDoublSlash() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource //calendar/test
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathStar() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar//test/*/other
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicate() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[1]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateParenteses() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something()]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateLT() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[1<3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateGT() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something>3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateEQ() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something=3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateSpace() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[1 < 3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateAt() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/@test[1 < 3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateAtInBrackets() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[@something < 3]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateQuote() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something = 'en']
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateDot() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something = 35.00]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testCondiditonTrue() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition true
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testCondiditonFalse() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionAddition() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition a + b
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionSubstraction() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition a - b
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionMultiplication() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 * 3
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionDivision() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 div 2
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionOr() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition true || false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionAnd() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition true && false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionXor() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition true ^ false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionInt() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionEq() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition true == false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionNeq() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition true != false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionNot() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition not(true)
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionGt() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 > 3
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionGeq() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 >= 3
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionLt() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 < 3
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionLeq() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar
					condition 4 <= 3
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionPar() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition (true)
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionFunctionNoArgs() {
		'''
		policy MyPolicy {
			subjects {SubjectId01}
			transformation calendar
			
			rule MyRule {
				action create
				resource /calendar/*
				condition functionCall()
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionFunctionOneArg() {
		'''
		policy MyPolicy {
			subjects {SubjectId01}
			transformation calendar
			
			rule MyRule {
				action create
				resource /calendar/*
				condition functionCall(true)
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionFunctionMultipleArgs() {
		'''
		policy MyPolicy {
			subjects {SubjectId01}
			transformation calendar
			
			rule MyRule {
				action create
				resource /calendar/*
				condition functionCall(true, 4, (2 >= 3))
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionTimeString() {
		'''
		policy MyPolicy {
			subjects {SubjectId01}
			transformation calendar
			
			rule MyRule {
				action create
				resource /calendar/*
				condition currentTime() >= '09:00am'
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testConditionXPath() {
		'''
		policy MyPolicy {
			subjects {SubjectId01}
			transformation calendar
			
			rule MyRule {
				action create
				resource /calendar/*
				condition someFunction(/calendar/event[id<5230])
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testCommentTop() {
		'''
			(: this should be ignored :)
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testCommentBottom() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
			}
			(: this should be ignored :)
		'''.parse.assertNoErrors
	}
	
	@Test
	def testCommentInsidePolicy() {
		'''
			policy MyPolicy {
				subjects {SubjectId01}
				transformation calendar
				(: this should be ignored :)
			}
		'''.parse.assertNoErrors
	}
}