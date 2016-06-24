module TypeCheckSpec where

import           GHCJS.CommonJS
import           Test.Hspec

spec :: Spec
spec = describe "TypeCheck" $
    describe "exports" $ do
        it "type checks" $ True `shouldBe` True
