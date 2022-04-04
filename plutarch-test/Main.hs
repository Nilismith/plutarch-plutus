{-# LANGUAGE CPP #-}

module Main (main) where

import qualified BaseSpec
import qualified ExtraSpec

#if MIN_VERSION_GLASGOW_HASKELL(9,0,0,0)
import qualified Plutarch.FieldSpec as FieldSpec
import qualified Plutarch.MonadicSpec as MonadicSpec
import Plutarch.Test.Run (runPlutarchSpec)
#else
import qualified Plutarch.FFISpec as FFISpec
import Test.Hspec (hspec)
#endif

import GHC.IO.Encoding (setLocaleEncoding, utf8)
import Plutarch.Test (Spec)

main :: IO ()
main = do
  setLocaleEncoding utf8

-- We use 'runPlutarchSpec' to test for unused goldens, but do so only in GHC
-- 9. Because, under GHC 8 certain modules are disabled (see the CPP below)
-- which leads to legitimately unused goldens detected leading to false
-- positive in test failure.
#if MIN_VERSION_GLASGOW_HASKELL(9,0,0,0)
  runPlutarchSpec spec
#else
  hspec spec
#endif

spec :: Spec
spec = do
  BaseSpec.spec
  ExtraSpec.spec
#if MIN_VERSION_GLASGOW_HASKELL(9,0,0,0)
  FieldSpec.spec
  MonadicSpec.spec
#else
  FFISpec.spec
#endif
