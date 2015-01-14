package jp.ac.nii.prg.bxauthz.tests

import com.google.inject.Inject
import jp.ac.nii.prg.bxauthz.BxAuthZInjectorProvider
import jp.ac.nii.prg.bxauthz.bxAuthZ.Model
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

import static extension jp.ac.nii.prg.bxauthz.utils.BxAuthZModelUtils.*

@InjectWith(BxAuthZInjectorProvider)
@RunWith(XtextRunner)

class ModelUtilsTest {
	@Inject extension ParseHelper<Model> parser
	@Inject extension ValidationTestHelper
	
	@Test
	def void testEmptyRules() {
		'''
		policy MyPolicy {
			subjects { Subj1 }
			transformation trans
		}
		'''.parse => [
			assertNoErrors
			Assert::assertEquals(true, policies.head.getReadRules.isEmpty())
			Assert::assertEquals(true, policies.head.getCreateRules.isEmpty())
			Assert::assertEquals(true, policies.head.getDeleteRules.isEmpty())
			Assert::assertEquals(true, policies.head.getUpdateRules.isEmpty())
		]
	}
	
	@Test
	def void testOneReadRule() {
		'''
		policy MyPolicy {
			subjects { Subj1 }
			transformation trans
			
			rule MyRule {
				action read
				resource /calendar/*
			}
		}
		'''.parse => [
			assertNoErrors
			Assert::assertEquals(1, policies.head.getReadRules.size())
			Assert::assertEquals(0, policies.head.getCreateRules.size())
			Assert::assertEquals(0, policies.head.getDeleteRules.size())
			Assert::assertEquals(0, policies.head.getUpdateRules.size())
		]
	}
	
	@Test
	def void testOneReadRuleWithOneWrite() {
		'''
		policy MyPolicy {
			subjects { Subj1 }
			transformation trans
			
			rule MyRule {
				action read
				resource /calendar/*
			}
			
			rule MyRule2 {
				action create
				resource /calendar/*
			}
		}
		'''.parse => [
			assertNoErrors
			Assert::assertEquals(1, policies.head.getReadRules.size())
			Assert::assertEquals(1, policies.head.getCreateRules.size())
			Assert::assertEquals(0, policies.head.getDeleteRules.size())
			Assert::assertEquals(0, policies.head.getUpdateRules.size())
		]
	}
	
	@Test
	def void testReadRuleComplex() {
		'''
		policy MyPolicy {
			subjects { Subj1 }
			transformation trans
			
			rule MyRule {
				action read
				action create
				resource /calendar/*
			}
			
			rule MyRule2 {
				action create
				resource /calendar/*
			}
			
			rule MyRule3 {
				action read
				resource /calview/*
			}
			
			rule MyRule4 {
				action create
				action delete
				resource /calview/*
			}
		}
		'''.parse => [
			assertNoErrors
			Assert::assertEquals(2, policies.head.getReadRules.size())
			Assert::assertEquals(3, policies.head.getCreateRules.size())
			Assert::assertEquals(1, policies.head.getDeleteRules.size())
			Assert::assertEquals(0, policies.head.getUpdateRules.size())
		]
	}
	
}