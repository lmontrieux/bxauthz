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
				subject SubjectId001
				transformation calendar
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testOneSimpleRule() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testOneRuleBoolCondition() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition isEnabled == true
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testAndCondition() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition true && true
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testOrCondition() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition true || true
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testXorCondition() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition true ^ true
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testNotCondition() {
		'''
			policy MyPolicy {
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/*
					condition not(true) == false
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPath() {
		'''
			policy MyPolicy {
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[1]
				}
			}
		'''.parse.assertNoErrors
	}
	
	@Test
	def testResourceXPathPredicateLT() {
		'''
			policy MyPolicy {
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
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
				subject SubjectId01
				transformation calendar
				
				rule MyRule {
					action create
					resource /calendar/test[something = 35.00]
				}
			}
		'''.parse.assertNoErrors
	}
}